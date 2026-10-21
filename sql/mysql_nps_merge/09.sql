SELECT 
                id, 
                status, 
                dispatched,
                post_sale_lot_id,
                customer_id,
                organization_id,
                campaign_id,
                type,
                custom_fields,
                second_dispatch_time,
                dispatch_time,
                create_time,
                update_time,
                delete_time,
                FROM_UNIXTIME(psd.create_time) as create_DT,
                FROM_UNIXTIME(psd.dispatch_time ) as dispatch_DT,
                FROM_UNIXTIME(psd.update_time ) as update_DT,
                FROM_UNIXTIME(psd.delete_time ) as delete_DT
            FROM common.post_sale_dispatch psd
            WHERE 
                FROM_UNIXTIME(psd.create_time) >= NOW() - INTERVAL 30 DAY
            AND 
                FROM_UNIXTIME(psd.create_time) <= NOW()
            AND 
            	 psd.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
