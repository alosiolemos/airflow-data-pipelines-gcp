SELECT
                count(imtd.interaction_uuid) 
                from demo_schema.interaction_metadata AS imtd 
                LEFT JOIN  demo_schema.metadata AS mtd on imtd.metadata_uuid = mtd.uuid
                WHERE DATE(TO_TIMESTAMP(imtd.created_at)) <= DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
        ;
