// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import { connect } from 'react-redux';
import { WrappedFieldMetaProps, WrappedFieldInputProps, WrappedFieldProps } from 'redux-form';
import { Vocabulary } from '~/models/vocabulary';
import { RootState } from '~/store/store';
import { getVocabulary } from '~/store/vocabulary/vocabulary-selectors';

export interface VocabularyProp {
    vocabulary: Vocabulary;
}

export const mapStateToProps = (state: RootState): VocabularyProp => ({
    vocabulary: getVocabulary(state.properties),
});

export const connectVocabulary = connect(mapStateToProps);

export const ITEMS_PLACEHOLDER: string[] = [];

export const hasError = ({ touched, invalid }: WrappedFieldMetaProps) =>
    touched && invalid;

export const getErrorMsg = (meta: WrappedFieldMetaProps) =>
    hasError(meta)
        ? meta.error
        : '';

export const handleBlur = ({ onBlur, value }: WrappedFieldInputProps) =>
    () =>
        onBlur(value);

export const handleSelect = ({ onChange }: WrappedFieldInputProps) => {
    return (item:PropFieldSuggestion) => {
        onChange(item.id);
    };
};

export const buildProps = ({ input, meta }: WrappedFieldProps) => {
    return {
        value: input.value,
        onChange: input.onChange,
        onBlur: handleBlur(input),
        items: ITEMS_PLACEHOLDER,
        onSelect: handleSelect(input),
        renderSuggestion: (item:PropFieldSuggestion) => item.label,
        error: hasError(meta),
        helperText: getErrorMsg(meta),
    };
};

export interface PropFieldSuggestion {
    "id": string;
    "label": string;
}
