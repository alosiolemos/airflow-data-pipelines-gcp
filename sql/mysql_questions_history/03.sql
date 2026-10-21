SELECT 
				id,
				status,
				csat_type,
				csat_answer,
				csat_comment,
				last_csat_answer,
				question_answer_id,
				create_time,
				update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT
            FROM 
                question_answer_csat
            WHERE 
			    FROM_UNIXTIME(create_time) BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'
        ;
