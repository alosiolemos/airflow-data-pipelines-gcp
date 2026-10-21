SELECT COUNT(*)
            FROM demo_schema.metadata
            WHERE DATE(TO_TIMESTAMP(created_at)) <= DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
        ;
