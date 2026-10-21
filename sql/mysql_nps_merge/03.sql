SELECT 
                cg.id, 
                cg.campaign_id,
                c.organization_id,
                cg.campaign_group_id, 
                cg.create_time, 
                cg.update_time,
                FROM_UNIXTIME(cg.create_time) AS create_DT,
                FROM_UNIXTIME(cg.update_time) AS update_DT
            FROM 
                common.campaign_campaign_group cg
            LEFT JOIN 
            	common.campaign c on c.id =cg.campaign_id
        	WHERE c.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
