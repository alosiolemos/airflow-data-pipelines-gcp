SELECT 
                id, 
                status,
                name,
                slug,
                website,
                create_time,
                update_time,
                FROM_UNIXTIME(create_time) AS create_DT,
                FROM_UNIXTIME(update_time) AS update_DT,
                country,
                state
            FROM organization
                where id in (795,3079,3088,3099,3108,3118)
        ;
