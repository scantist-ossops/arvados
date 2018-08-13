// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import { ContextMenuActionSet } from "../context-menu-action-set";
import { collectionPanelFilesAction } from "~/store/collection-panel/collection-panel-files/collection-panel-files-actions";
import { openMultipleFilesRemoveDialog } from "~/views-components/file-remove-dialog/multiple-files-remove-dialog";
import { createCollectionWithSelected } from "~/views-components/create-collection-dialog-with-selected/create-collection-dialog-with-selected";


export const collectionFilesActionSet: ContextMenuActionSet = [[{
    name: "Select all",
    execute: (dispatch) => {
        dispatch(collectionPanelFilesAction.SELECT_ALL_COLLECTION_FILES());
    }
}, {
    name: "Unselect all",
    execute: (dispatch) => {
        dispatch(collectionPanelFilesAction.UNSELECT_ALL_COLLECTION_FILES());
    }
}, {
    name: "Remove selected",
    execute: (dispatch, resource) => {
        dispatch(openMultipleFilesRemoveDialog());
    }
}, {
    name: "Download selected",
    execute: (dispatch, resource) => {
        return;
    }
}, {
    name: "Create a new collection with selected",
    execute: (dispatch) => {
        dispatch<any>(createCollectionWithSelected());
    }
}]];
