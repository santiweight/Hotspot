/*
 * Copyright 2010-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except i n compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import Foundation
import AWSDynamoDB

let AWSSampleDynamoDBTableName = "Events"

class DDBDynamoDBManger : NSObject {
    class func describeTable() -> AWSTask<AnyObject> {
        let dynamoDB = AWSDynamoDB.default()

        // See if the test table exists.
        let describeTableInput = AWSDynamoDBDescribeTableInput()
        describeTableInput?.tableName = AWSSampleDynamoDBTableName
        return dynamoDB.describeTable(describeTableInput!) as! AWSTask<AnyObject>
    }

    class func createTable() -> AWSTask<AnyObject> {
        let dynamoDB = AWSDynamoDB.default()

        //Create the test table
        let hashKeyAttributeDefinition = AWSDynamoDBAttributeDefinition()
        hashKeyAttributeDefinition?.attributeName = "EventId"
        hashKeyAttributeDefinition?.attributeType = AWSDynamoDBScalarAttributeType.N

        let hashKeySchemaElement = AWSDynamoDBKeySchemaElement()
        hashKeySchemaElement?.attributeName = "EventId"
        hashKeySchemaElement?.keyType = AWSDynamoDBKeyType.hash

        let rangeKeyAttributeDefinition = AWSDynamoDBAttributeDefinition()
        rangeKeyAttributeDefinition?.attributeName = "EventTitle"
        rangeKeyAttributeDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S

        let rangeKeySchemaElement = AWSDynamoDBKeySchemaElement()
        rangeKeySchemaElement?.attributeName = "EventTitle"
        rangeKeySchemaElement?.keyType = AWSDynamoDBKeyType.range

        //Add non-key attributes
        let latAttrDef = AWSDynamoDBAttributeDefinition()
        latAttrDef?.attributeName = "Latitude"
        latAttrDef?.attributeType = AWSDynamoDBScalarAttributeType.N

        let longAttrDef = AWSDynamoDBAttributeDefinition()
        longAttrDef?.attributeName = "Longitude"
        longAttrDef?.attributeType = AWSDynamoDBScalarAttributeType.N
        
        let curPplAttrDef = AWSDynamoDBAttributeDefinition()
        curPplAttrDef?.attributeName = "CurrentPeople"
        curPplAttrDef?.attributeType = AWSDynamoDBScalarAttributeType.N
        
        let expPplAttrDef = AWSDynamoDBAttributeDefinition()
        expPplAttrDef?.attributeName = "ExpectedPeople"
        expPplAttrDef?.attributeType = AWSDynamoDBScalarAttributeType.N

        let provisionedThroughput = AWSDynamoDBProvisionedThroughput()
        provisionedThroughput?.readCapacityUnits = 1
        provisionedThroughput?.writeCapacityUnits = 1

        //Create Global Secondary Index
        let rangeKeyArray = ["Latitude", "Longitude", "CurrentPeople", "ExpectedPeople"]
        var gsiArray = [AWSDynamoDBGlobalSecondaryIndex]()

        for rangeKey in rangeKeyArray {
            let gsi = AWSDynamoDBGlobalSecondaryIndex()

            let gsiHashKeySchema = AWSDynamoDBKeySchemaElement()
            gsiHashKeySchema?.attributeName = "EventTitle"
            gsiHashKeySchema?.keyType = AWSDynamoDBKeyType.hash

            let gsiRangeKeySchema = AWSDynamoDBKeySchemaElement()
            gsiRangeKeySchema?.attributeName = rangeKey
            gsiRangeKeySchema?.keyType = AWSDynamoDBKeyType.range

            let gsiProjection = AWSDynamoDBProjection()
            gsiProjection?.projectionType = AWSDynamoDBProjectionType.all;

            gsi?.keySchema = [gsiHashKeySchema!,gsiRangeKeySchema!];
            gsi?.indexName = rangeKey;
            gsi?.projection = gsiProjection;
            gsi?.provisionedThroughput = provisionedThroughput;

            gsiArray.append(gsi!)
        }

        //Create TableInput
        let createTableInput = AWSDynamoDBCreateTableInput()
        createTableInput?.tableName = AWSSampleDynamoDBTableName;
        createTableInput?.attributeDefinitions = [hashKeyAttributeDefinition!, rangeKeyAttributeDefinition!, latAttrDef!, longAttrDef!,curPplAttrDef!, expPplAttrDef!]
        createTableInput?.keySchema = [hashKeySchemaElement!, rangeKeySchemaElement!]
        createTableInput?.provisionedThroughput = provisionedThroughput
        createTableInput?.globalSecondaryIndexes = gsiArray

        return dynamoDB.createTable(createTableInput!).continueOnSuccessWith(block: { task -> AnyObject? in
            guard task.result != nil else {
                return task
            }

            // Wait for up to 4 minutes until the table becomes ACTIVE.

            let describeTableInput = AWSDynamoDBDescribeTableInput()
            describeTableInput?.tableName = AWSSampleDynamoDBTableName;
            let describeTask = dynamoDB.describeTable(describeTableInput!)

            var localTask:AWSTask<AnyObject>?
            for _ in 0...15 {
                localTask = describeTask.continueOnSuccessWith(block: { task -> AnyObject? in
                    let describeTableOutput:AWSDynamoDBDescribeTableOutput = task.result!
                    let tableStatus = describeTableOutput.table!.tableStatus
                    if tableStatus == AWSDynamoDBTableStatus.active {
                        return task
                    }

                    sleep(15)
                    return dynamoDB .describeTable(describeTableInput!)
                })
            }

            return localTask
        })

    }
}

class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {

    var EventId:String?
    var EventTitle:String?

    //set the default values of scores, wins and losses to 0
    var Latitude:NSNumber? = 0
    var Longitude:NSNumber? = 0
    var CurrentPeople:NSNumber? = 0
    var ExpectedPeople:NSNumber? = 0


    //should be ignored according to ignoreAttributes
    var internalName:String?
    var internalState:NSNumber?

    class func dynamoDBTableName() -> String {
        return AWSSampleDynamoDBTableName
    }

    class func hashKeyAttribute() -> String {
        return "EventId"
    }
    
    class func rangeKeyAttribute() -> String {
        return "EventTitle"
    }
    
    class func ignoreAttributes() -> [String] {
        return ["internalName", "internalState"]
    }
}

