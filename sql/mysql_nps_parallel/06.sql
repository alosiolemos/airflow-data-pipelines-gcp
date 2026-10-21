SELECT id,question_id,type, 
            status,
            create_time,
            update_time,
            organization_id,
            campaign_id from question_answer
            WHERE FROM_UNIXTIME(create_time) BETWEEN '2024-01-01' AND '2025-02-11'
        ;
