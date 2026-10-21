SELECT 
            uuid,
            survey_uuid,
            item_uuid,
            item_type,
            created_at,
            category_uuid,
            parent_uuid,
            jsonb_extract_path_text(question::jsonb, 'pt_BR') AS question,
            public_hash,
            TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,
            TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
        FROM 
            demo_schema.surveys_items
                ;
