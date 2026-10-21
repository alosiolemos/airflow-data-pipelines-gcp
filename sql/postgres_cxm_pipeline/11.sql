SELECT 
                    COUNT(*)
                FROM 
                    demo_schema.interactions
                WHERE 
                    (DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') =  DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
                        AND answered_at = 0)
                    OR (DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') =  DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day'))
        ;
