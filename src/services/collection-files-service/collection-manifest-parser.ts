// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import { KeepManifestStream, KeepManifestStreamFile, KeepManifest } from "../../models/keep-manifest";

/**
 * Documentation [http://doc.arvados.org/api/storage.html](http://doc.arvados.org/api/storage.html)
 */
export const parseKeepManifestText: (text: string) => KeepManifestStream[] = (text: string) =>
    text
        .split(/\n/)
        .filter(streamText => streamText.length > 0)
        .map(parseKeepManifestStream);

/**
 * Documentation [http://doc.arvados.org/api/storage.html](http://doc.arvados.org/api/storage.html)
 */
export const parseKeepManifestStream = (stream: string): KeepManifestStream => {
    const tokens = stream.split(' ');
    return {
        name: streamName(tokens),
        locators: locators(tokens),
        files: files(tokens)
    };
};

export const stringifyKeepManifest = (manifest: KeepManifest) =>
    manifest.map(stringifyKeepManifestStream).join('');

export const stringifyKeepManifestStream = (stream: KeepManifestStream) =>
    `.${stream.name} ${stream.locators.join(' ')} ${stream.files.map(stringifyFile).join(' ')}\n`;

const FILE_LOCATOR_REGEXP = /^([0-9a-f]{32})\+([0-9]+)(\+[A-Z][-A-Za-z0-9@_]*)*$/;

const FILE_REGEXP = /([0-9]+):([0-9]+):(.*)/;

const streamName = (tokens: string[]) => tokens[0].slice(1);

const locators = (tokens: string[]) => tokens.filter(isFileLocator);

const files = (tokens: string[]) => tokens.filter(isFile).map(parseFile);

const isFileLocator = (token: string) => FILE_LOCATOR_REGEXP.test(token);

const isFile = (token: string) => FILE_REGEXP.test(token);

const parseFile = (token: string): KeepManifestStreamFile => {
    const match = FILE_REGEXP.exec(token);
    const [position, size, name] = match!.slice(1);
    return { name, position, size: parseInt(size, 10) };
};

const stringifyFile = (file: KeepManifestStreamFile) =>
    `${file.position}:${file.size}:${file.name}`;
