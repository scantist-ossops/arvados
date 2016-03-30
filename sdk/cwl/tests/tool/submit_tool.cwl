class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: debian:8
inputs:
  - id: x
    type: File
    default:
      class: File
      path: blub.txt
    inputBinding:
      position: 1
outputs: []
baseCommand: cat
