// Copyright (C) The Arvados Authors. All rights reserved.
//
// SPDX-License-Identifier: AGPL-3.0

import * as _ from "lodash";
import CommonResourceService, { Resource, ListResults } from "../../common/api/common-resource-service";
import FilterBuilder from "../../common/api/filter-builder";
import OrderBuilder from "../../common/api/order-builder";
import { AxiosInstance } from "axios";
import { GroupResource } from "../../models/group";
import { CollectionResource } from "../../models/collection";
import { ProjectResource } from "../../models/project";
import { WorkflowResource } from "../../models/workflow";
import { ProcessResource } from "../../models/process";

interface ContensArguments {
    limit?: number;
    offset?: number;
    order?: OrderBuilder;
    filters?: FilterBuilder;
    recursive?: boolean;
}

export type GroupContentsResource =
    CollectionResource |
    ProjectResource |
    WorkflowResource |
    ProcessResource;

export default class GroupsService extends CommonResourceService<GroupResource> {

    constructor(serverApi: AxiosInstance) {
        super(serverApi, "groups");
    }

    contents(uuid: string, args: ContensArguments = {}): Promise<ListResults<GroupContentsResource>> {
        const { filters, order, ...other } = args;
        const params = {
            ...other,
            filters: filters ? filters.serialize() : undefined,
            order: order ? order.getOrder() : undefined
        };
        return this.serverApi
            .get(this.resourceType + `${uuid}/contents/`, {
                params: CommonResourceService.mapKeys(_.snakeCase)(params)
            })
            .then(CommonResourceService.mapResponseKeys);
    }
}