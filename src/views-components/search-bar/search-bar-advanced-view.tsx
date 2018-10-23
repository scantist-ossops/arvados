// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import * as React from 'react';
import { reduxForm, reset, InjectedFormProps } from 'redux-form';
import { compose, Dispatch } from 'redux';
import { Paper, StyleRulesCallback, withStyles, WithStyles, Button, Grid, IconButton, CircularProgress } from '@material-ui/core';
import { SearchView } from '~/store/search-bar/search-bar-reducer';
import { SEARCH_BAR_ADVANCE_FORM_NAME, saveQuery } from '~/store/search-bar/search-bar-actions';
import { ArvadosTheme } from '~/common/custom-theme';
import { CloseIcon } from '~/components/icon/icon';
import { SearchBarAdvanceFormData } from '~/models/search-bar';
import {
    SearchBarTypeField, SearchBarClusterField, SearchBarProjectField, SearchBarTrashField,
    SearchBarDateFromField, SearchBarDateToField, SearchBarPropertiesField,
    SearchBarSaveSearchField, SearchBarQuerySearchField
} from '~/views-components/form-fields/search-bar-form-fields';

type CssRules = 'container' | 'closeIcon' | 'label' | 'buttonWrapper'
    | 'button' | 'circularProgress' | 'searchView' | 'selectGrid';

const styles: StyleRulesCallback<CssRules> = (theme: ArvadosTheme) => ({
    container: {
        padding: theme.spacing.unit * 2,
        borderBottom: `1px solid ${theme.palette.grey["200"]}`
    },
    closeIcon: {
        position: 'absolute',
        top: '12px',
        right: '12px'
    },
    label: {
        color: theme.palette.grey["500"],
        fontSize: '0.8125rem',
        alignSelf: 'center'
    },
    buttonWrapper: {
        paddingRight: '14px',
        paddingTop: '14px',
        position: 'relative',
    },
    button: {
        boxShadow: 'none'
    },
    circularProgress: {
        position: 'absolute',
        top: -9,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto'
    },
    searchView: {
        color: theme.palette.common.black,
        borderRadius: `0 0 ${theme.spacing.unit / 2}px ${theme.spacing.unit / 2}px`
    },
    selectGrid: {
        marginBottom: theme.spacing.unit * 2
    }
});

interface SearchBarAdvancedViewDataProps {
    submitting: boolean;
    invalid: boolean;
    pristine: boolean;
}

export interface Tags {
    values?: {
        properties?: { key: string, value: string },
    };
}

interface SearchBarAdvancedViewActionProps {
    setView: (currentView: string) => void;
    saveQuery: (data: SearchBarAdvanceFormData) => void;
    tags: Tags;
}

type SearchBarAdvancedViewProps = SearchBarAdvancedViewActionProps & SearchBarAdvancedViewDataProps
    & InjectedFormProps & WithStyles<CssRules>;

const validate = (values: any) => {
    const errors: any = {};

    if (values.dateFrom && values.dateTo) {
        if (new Date(values.dateFrom).getTime() > new Date(values.dateTo).getTime()) {
            errors.dateFrom = 'Invalid date';
        }
    }

    return errors;
};

export const SearchBarAdvancedView = compose(
    reduxForm<SearchBarAdvanceFormData, SearchBarAdvancedViewActionProps>({
        form: SEARCH_BAR_ADVANCE_FORM_NAME,
        validate,
        onSubmit: (data: SearchBarAdvanceFormData, dispatch: Dispatch) => {
            dispatch<any>(saveQuery(data));
            dispatch(reset(SEARCH_BAR_ADVANCE_FORM_NAME));
        }
    }),
    withStyles(styles))(
        ({ classes, setView, handleSubmit, submitting, invalid, pristine, tags }: SearchBarAdvancedViewProps) =>
            <Paper className={classes.searchView}>
                <form onSubmit={handleSubmit}>
                    <Grid container direction="column" justify="flex-start" alignItems="flex-start">
                        <Grid item xs={12} container className={classes.container}>
                            <Grid item container xs={12} className={classes.selectGrid}>
                                <Grid item xs={2} className={classes.label}>Type</Grid>
                                <Grid item xs={5}>
                                    <SearchBarTypeField />
                                </Grid>
                            </Grid>
                            <Grid item container xs={12} className={classes.selectGrid}>
                                <Grid item xs={2} className={classes.label}>Cluster</Grid>
                                <Grid item xs={5}>
                                    <SearchBarClusterField />
                                </Grid>
                            </Grid>
                            <Grid item container xs={12}>
                                <Grid item xs={2} className={classes.label}>Project</Grid>
                                <Grid item xs={5}>
                                    <SearchBarProjectField />
                                </Grid>
                            </Grid>
                            <Grid item container xs={12}>
                                <Grid item xs={2} className={classes.label} />
                                <Grid item xs={5}>
                                    <SearchBarTrashField />
                                </Grid>
                            </Grid>
                            <IconButton onClick={() => setView(SearchView.BASIC)} className={classes.closeIcon}>
                                <CloseIcon />
                            </IconButton>
                        </Grid>
                        <Grid container item xs={12} className={classes.container} spacing={16}>
                            <Grid item xs={2} className={classes.label}>Date modified</Grid>
                            <Grid item xs={4}>
                                <SearchBarDateFromField />
                            </Grid>
                            <Grid item xs={4}>
                                <SearchBarDateToField />
                            </Grid>
                        </Grid>
                        <Grid container item xs={12} className={classes.container}>
                            <SearchBarPropertiesField />
                            <Grid container item xs={12} justify="flex-start" alignItems="center" spacing={16}>
                                <Grid item xs={2} className={classes.label} />
                                <Grid item xs={4}>
                                    <SearchBarSaveSearchField />
                                </Grid>
                                <Grid item xs={4}>
                                    <SearchBarQuerySearchField />
                                </Grid>
                            </Grid>
                            <Grid container item xs={12} justify='flex-end'>
                                <div className={classes.buttonWrapper}>
                                    <Button type="submit" className={classes.button}
                                        disabled={invalid || submitting || pristine || !!(tags && !tags.values!.properties)}
                                        color="primary"
                                        size='small'
                                        variant="contained">
                                        Search
                                    </Button>
                                    {submitting && <CircularProgress size={20} className={classes.circularProgress} />}
                                </div>
                            </Grid>
                        </Grid>
                    </Grid>
                </form>
            </Paper>
    );
