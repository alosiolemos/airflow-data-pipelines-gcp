SELECT  
				qn.id, 
                qn.question_answer_id,
                qn.status, 
                qn.nps_comment, 
                qn.nps_answer,
                qn.last_nps_answer, 
                qn.create_time,
                qn.update_time,
                q.organization_id,
                FROM_UNIXTIME(qn.create_time) AS create_DT,
                FROM_UNIXTIME(qn.update_time) AS update_DT 
			from common.question_answer_nps qn
			left join common.question_answer q on q.id =qn.question_answer_id
            WHERE 
                FROM_UNIXTIME(qn.create_time) >= NOW() - INTERVAL 30 DAY
            AND 
                FROM_UNIXTIME(qn.create_time) <= NOW()
            AND 
            	 q.organization_id in (1001, 1002, 1003, 1004, 1005, 1006)
        ;
