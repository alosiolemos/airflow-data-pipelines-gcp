SELECT 
                id,
                post_sale_dispatch_id,
                customer_id,
                campaign_id,
                organization_id,
                status,
                status_id,
                analytics_status,
                priority,
                category_text, 
                create_time,
                update_time,
                delete_time,
                answer_elapsed_time,
                FROM_UNIXTIME(psa.create_time) as create_DT,
                FROM_UNIXTIME(psa.update_time) as update_DT,
                FROM_UNIXTIME(psa.delete_time) as delete_DT
            FROM common.post_sale_action psa
            WHERE psa.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
                AND FROM_UNIXTIME(psa.create_time) >= NOW() - INTERVAL 30 DAY
                AND FROM_UNIXTIME(psa.create_time) <= NOW()
        ;
