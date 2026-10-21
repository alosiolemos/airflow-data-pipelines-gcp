SELECT 
                id,
                status,
                code,
                name,
                tags,
                organization_id,
                update_time,
                campaign_key,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                common.campaign
                where organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
