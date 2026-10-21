SELECT 
                uuid,
                name,
                survey_uuid,    
                public_hash,
                status,
                distribution_channel,
                distributed_at,
                created_at,
                schedule_at,    
                modified_at,
                reminder_at,
                validity_at,
                deleted_at,
                total_processed_counter,
                total_lines,
                TO_CHAR(TO_TIMESTAMP(schedule_at), 'YYYY-MM-DD HH24:MI') AS schedule_dt,
                TO_CHAR(TO_TIMESTAMP(modified_at), 'YYYY-MM-DD HH24:MI') AS modified_dt,
                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,
                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') AS deleted_dt,
                TO_CHAR(TO_TIMESTAMP(validity_at), 'YYYY-MM-DD HH24:MI') AS validity_dt,
                TO_CHAR(TO_TIMESTAMP(reminder_at), 'YYYY-MM-DD HH24:MI') AS reminder_dt,
                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
            FROM 
                demo_schema.distributions
            WHERE DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') = DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
        ;
