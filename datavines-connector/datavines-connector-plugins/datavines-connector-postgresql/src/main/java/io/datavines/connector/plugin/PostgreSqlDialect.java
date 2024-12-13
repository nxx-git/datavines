/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.datavines.connector.plugin;

import io.datavines.common.utils.StringUtils;

import java.util.Map;

import static io.datavines.common.ConfigConstants.*;

public class PostgreSqlDialect extends JdbcDialect {

    @Override
    public Map<String, String> getDialectKeyMap() {
        super.getDialectKeyMap();
        dialectKeyMap.put(REGEX_KEY, "${column} ~ '${regexp}'");
        dialectKeyMap.put(NOT_REGEX_KEY, "${column} !~ '${regexp}'");
        dialectKeyMap.put(LENGTH_KEY, "length(${column}::text)");
        dialectKeyMap.put(IF_CASE_KEY, "case when ${column} is null then 'NULL' else cast(${column} as ${string_type}) end ");
        return dialectKeyMap;
    }

    @Override
    public String getDriver() {
        return "org.postgresql.Driver";
    }

    @Override
    public boolean invalidateItemCanOutputToSelf(){
        return true;
    }

    @Override
    public String getErrorDataScript(Map<String, String> configMap) {
        String errorDataFileName = configMap.get("error_data_file_name");
        if (StringUtils.isNotEmpty(errorDataFileName)) {
            return "select * from " + errorDataFileName;
        }
        return null;
    }

    @Override
    public String getFullQualifiedTableName(String database, String schema, String table, boolean needQuote) {
        if (needQuote) {
            table = quoteIdentifier(table);
            if (!StringUtils.isEmptyOrNullStr(schema)) {
                table = quoteIdentifier(schema) + "." + table;
            }
        } else {
            if (!StringUtils.isEmptyOrNullStr(schema)) {
                table = schema + "." + table;
            }
        }
        return table;
    }
}
