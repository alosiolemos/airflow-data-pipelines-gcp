SELECT COUNT(*)
            FROM demo_schema.interaction_answers
            WHERE DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') BETWEEN 
                    (CURRENT_DATE - INTERVAL '5 day') AND 
                    (CURRENT_DATE - INTERVAL '0 day')
        ;
