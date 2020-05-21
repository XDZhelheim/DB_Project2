--接入别的函数 jdbc不用调用
create function recommend_path_fuzzy(start_station character varying, arrive_station character varying) returns SETOF path_rough
    language plpgsql
as
$$
declare
    tmpv  varchar;
    tmpi  int;
    tmpd  double precision;
    city1 varchar;
    city2 varchar;
begin
    tmpv = '';
    tmpi = 0;
    tmpd = 0.0;

    select city into city1 from station s where s.station_name = start_station;
    select city into city2 from station s where s.station_name = arrive_station;

    return query (select t1.train_num                                     as first_train_num,
                         t1.train_type                                    as first_train_type,
                         t1.station_name                                  as first_from,
                         t2.station_name                                  as first_to,
                         t1.depart_time                                   as first_depart,
                         t2.arrive_time                                   as first_arrive,
                         t1.stop_num,
                         t2.stop_num,
                         cast(round(cast(0.8 * (t2.price_from_start_station - t1.price_from_start_station) as
                                        numeric), 2) as double precision),
                         tmpv,
                         tmpv,
                         tmpv,
                         tmpv,
                         tmpv,
                         tmpi,
                         tmpi,
                         tmpd,
                         subtract_time_train(t1.depart_time, t2.arrive_time, t1.train_num,
                                             t1.stop_num, t2.stop_num)    as total_time,
                         cast(round(cast(0.8 * (t2.price_from_start_station - t1.price_from_start_station) as
                                        numeric), 2) as double precision) as total_price
                  from inquire_table t1
                           join inquire_table t2 on t1.train_num = t2.train_num and t1.stop_num < t2.stop_num
                  where t1.station_name in (select station_name from station where city = city1)
                    and t2.station_name in (select station_name from station where city = city2)
                  union
                  select t1.train_num                                                   as first_train_num,
                         t1.train_type                                                  as first_train_type,
                         t1.station_name                                                as first_from,
                         t2.station_name                                                as first_to,
                         t1.depart_time                                                 as first_depart,
                         t2.arrive_time                                                 as first_arrive,
                         t1.stop_num,
                         t2.stop_num,
                         cast(round(cast(0.8 * (t2.price_from_start_station - t1.price_from_start_station) as
                                        numeric), 2) as double precision),
                         t3.train_num                                                   as first_train_num,
                         t3.train_type                                                  as first_train_type,
                         t4.station_name                                                as first_to,
                         t3.depart_time                                                 as first_depart,
                         t4.arrive_time                                                 as first_arrive,
                         t3.stop_num,
                         t4.stop_num,
                         cast(round(cast(0.8 * (t4.price_from_start_station - t3.price_from_start_station) as
                                        numeric), 2) as double precision),
                         add_time(add_time(subtract_time_train(t3.depart_time, t4.arrive_time, t3.train_num,
                                                               t3.stop_num, t4.stop_num),
                                           subtract_time_train(t1.depart_time, t2.arrive_time, t1.train_num,
                                                               t1.stop_num, t2.stop_num)
                                      ), subtract_time_transfer(t2.arrive_time, t3.depart_time))
                                                                                        as total_time,
                         round(cast(0.8 * (t4.price_from_start_station - t3.price_from_start_station +
                                           t2.price_from_start_station -
                                           t1.price_from_start_station) as numeric), 2) as total_price
                  from inquire_table t1
                           join inquire_table t2 on t1.train_num = t2.train_num and t1.stop_num < t2.stop_num
                           join inquire_table t3 on t3.station_name = t2.station_name
                           join inquire_table t4 on t4.train_num = t3.train_num and t3.stop_num < t4.stop_num
                  where t1.station_name in (select station_name from station where city = city1)
                    and t4.station_name in (select station_name from station where city = city2)
    );
end ;
$$;

