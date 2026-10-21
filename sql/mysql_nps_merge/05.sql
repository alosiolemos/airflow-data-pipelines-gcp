SELECT 
                s.id,
                s.campaign_id,
                c.organization_id,
                s.create_time, 
                s.update_time, 
                s.delete_time,
                FROM_UNIXTIME(s.create_time) AS create_DT,
                FROM_UNIXTIME(s.update_time) AS update_DT
            FROM 
                common.survey s
            LEFT JOIN 
            	common.campaign c on c.id =s.campaign_id
        	WHERE c.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
