SELECT 
                id, 
                question_answer_id,
                status, 
                nps_comment, 
                nps_answer,
                last_nps_answer, 
                create_time,
                update_time
            FROM 
                common.question_answer_nps
            WHERE FROM_UNIXTIME(create_time) BETWEEN '2024-01-01' AND '2025-02-11'
        ;
