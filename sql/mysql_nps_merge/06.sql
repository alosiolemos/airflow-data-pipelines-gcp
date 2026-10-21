SELECT 
                q.id,
                q.survey_id, 
                c.organization_id,
                q.status,
                q.type,
                q.title,    
                q.question,
                q.subtitle,
                q.create_time,
                q.update_time,
                q.delete_time,
                FROM_UNIXTIME(q.create_time) AS create_DT,
                FROM_UNIXTIME(q.update_time) AS update_DT
            FROM 
                common.question q
            LEFT JOIN 
            	common.survey s on s.id = q.survey_id
        	LEFT JOIN 
        		common.campaign c on c.id = s.campaign_id 
        	WHERE 
        		c.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
