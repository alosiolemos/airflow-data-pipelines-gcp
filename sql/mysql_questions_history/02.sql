SELECT 
                id, 
                question_answer_id,
                status, 
                nps_comment, 
                nps_answer,
                last_nps_answer, 
                create_time,
                update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                common.question_answer_nps
            WHERE 
                FROM_UNIXTIME(create_time) BETWEEN '2021-06-30 23:59:59' AND '2021-12-31 23:59:59'
        ;
