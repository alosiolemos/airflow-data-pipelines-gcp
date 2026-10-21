SELECT 
                id, 
                name, 
                organization_id,
                create_time,
                update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                common.campaign_group
            WHERE 
            	organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
