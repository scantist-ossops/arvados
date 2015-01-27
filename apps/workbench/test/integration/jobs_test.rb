require 'fileutils'
require 'tmpdir'

require 'integration_helper'

class JobsTest < ActionDispatch::IntegrationTest

  def fakepipe_with_log_data
    content =
      "2014-01-01_12:00:01 zzzzz-8i9sb-0vsrcqi7whchuil 0  log message 1\n" +
      "2014-01-01_12:00:02 zzzzz-8i9sb-0vsrcqi7whchuil 0  log message 2\n" +
      "2014-01-01_12:00:03 zzzzz-8i9sb-0vsrcqi7whchuil 0  log message 3\n"
    StringIO.new content, 'r'
  end

  test "add job description" do
    need_javascript
    visit page_with_token("active", "/jobs")

    # go to job running the script "doesnotexist"
    within first('tr', text: 'doesnotexist') do
      find("a").click
    end

    # edit job description
    within('.arv-description-as-subtitle') do
      find('.fa-pencil').click
      find('.editable-input textarea').set('*Textile description for job* - "Go to dashboard":/')
      find('.editable-submit').click
    end
    wait_for_ajax

    # Verify edited description
    assert page.has_no_text? '*Textile description for job*'
    assert page.has_text? 'Textile description for job'
    assert page.has_link? 'Go to dashboard'
    click_link 'Go to dashboard'
    assert page.has_text? 'Active pipelines'
  end

  test "view job log" do
    need_javascript
    job = api_fixture('jobs')['job_with_real_log']

    IO.expects(:popen).returns(fakepipe_with_log_data)

    visit page_with_token("active", "/jobs/#{job['uuid']}")
    assert page.has_text? job['script_version']

    click_link 'Log'
    wait_for_ajax
    assert page.has_text? 'Started at'
    assert page.has_text? 'Finished at'
    assert page.has_text? 'log message 1'
    assert page.has_text? 'log message 2'
    assert page.has_text? 'log message 3'
    assert page.has_no_text? 'Showing only 100 bytes of this log'
  end

  test 'view partial job log' do
    need_javascript
    # This config will be restored during teardown by ../test_helper.rb:
    Rails.configuration.log_viewer_max_bytes = 100

    IO.expects(:popen).returns(fakepipe_with_log_data)
    job = api_fixture('jobs')['job_with_real_log']

    visit page_with_token("active", "/jobs/#{job['uuid']}")
    assert page.has_text? job['script_version']

    click_link 'Log'
    wait_for_ajax
    assert page.has_text? 'Showing only 100 bytes of this log'
  end

  [
    ['foobar', false, false],
    ['job_with_latest_version', true, false],
    ['job_with_latest_version', true, true],
  ].each do |job_name, expect_options, use_latest|
    test "Rerun #{job_name} job, expect options #{expect_options},
          and use latest version option #{use_latest}" do
      need_javascript

      job = api_fixture('jobs')[job_name]
      visit page_with_token 'active', '/jobs/'+job['uuid']

      if expect_options
        assert_text 'supplied_script_version: master'
      else
        assert_text 'supplied_script_version: (none)'
      end

      assert_triggers_dom_event 'shown.bs.modal' do
        find('a,button', text: 'Re-run job...').click
      end
      within('.modal-dialog') do
        assert_selector 'a,button', text: 'Run now'
        assert_selector 'a,button', text: 'Cancel'
        page.choose('script_use_latest') if use_latest
        find('button', text: 'Run now').click
      end

      # Re-run job does not actually work and we see Fiddlesticks.
      # So, let's make sure the correct script version is sought.
      if expect_options && use_latest
        assert_text "Script version #{job['supplied_script_version']} does not resolve to a commit"
      else
        assert_text "Script version #{job['script_version']} does not resolve to a commit"
      end
    end
  end
end
