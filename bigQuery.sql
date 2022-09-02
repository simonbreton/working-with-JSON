
# read JSON nested Object (map)

{
   "item_1": {
      "cost": 100,
      "name": "My Product",
      "category": "My Category"
   },
   "item_2": {
      "cost": 150,
      "name": "My Other Product",
      "category": "My Other Category"
   }
}

# BigQuery need array
# Temp function is loop throught object and create an array which can be unnest

CREATE TEMP FUNCTION
  unnest_json(str STRING)
  RETURNS ARRAY<STRING>
  LANGUAGE js AS r"""
  var obj = JSON.parse(str);
  var keys = Object.keys(obj);
  var arr = [];
  for (i = 0; i < keys.length; i++) {
    arr.push(JSON.stringify(obj[keys[i]]));
  }
  return arr;
""";
SELECT
  JSON_EXTRACT_SCALAR(itms,'$.name') AS name,
  JSON_EXTRACT(itms,'$.stats.attackdamage') AS attackdamage
FROM
  `tft-project-360712.static_data.champion-list`,
  UNNEST(unnest_json(TO_JSON_STRING(DATA))) AS itms
GROUP BY
  1,2