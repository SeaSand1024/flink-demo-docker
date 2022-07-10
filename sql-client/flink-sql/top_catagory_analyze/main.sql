--聚合商品点击曝光视图
CREATE VIEW rich_user_behavior AS
SELECT U.user_id, U.item_id, U.behavior, C.parent_category_name as category_name
FROM user_behavior AS U
         LEFT JOIN category_dim FOR SYSTEM_TIME AS OF U.proctime AS C
                   ON U.category_id = C.sub_category_id;

-- mainStream start --
INSERT INTO top_category
SELECT category_name, COUNT(*) AS buy_cnt
FROM rich_user_behavior
WHERE behavior = 'buy'
GROUP BY category_name;