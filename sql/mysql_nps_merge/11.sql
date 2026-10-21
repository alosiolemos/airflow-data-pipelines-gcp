SELECT 
                id,
                name,
                email, 
                organization_id,
                create_time,
                FROM_UNIXTIME(cc.create_time) as dt_create_time
            FROM common.customer cc
            WHERE 
                FROM_UNIXTIME(cc.create_time) >= NOW() - INTERVAL 30 DAY
            AND 
                FROM_UNIXTIME(cc.create_time) <= NOW()
            AND 
            	 cc.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
