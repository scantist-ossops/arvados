// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import { default as unionize, ofType, UnionOf } from "unionize";
import { CollectionPanelFilesState, CollectionPanelFile } from "./collection-panel-files-state";

export const collectionPanelFilesAction = unionize({
    SET_COLLECTION_FILES: ofType<{ files: CollectionPanelFilesState }>(),
    TOGGLE_COLLECTION_FILE_COLLAPSE: ofType<{ id: string }>(),
    TOGGLE_COLLECTION_FILE_SELECTION: ofType<{ id: string }>()
}, { tag: 'type', value: 'payload' });

export type CollectionPanelFilesAction = UnionOf<typeof collectionPanelFilesAction>;