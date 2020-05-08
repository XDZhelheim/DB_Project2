----5.7

--这样会返回一个表
select *
from recommend_path('北京西', '深圳北');
--这样会返回一个结果集
select recommend_path('北京西', '深圳北');

--更新price
update train
set price_from_start_station=modify_price(train_num, stop_num, train_type, arrive_time);

--建临时表 用于返回推荐路径
create table path_recommend
(
    first_train_num   varchar,
    first_train_type  character varying,
    first_price       double precision,
    first_from        character varying,
    first_to          character varying,
    first_depart      character varying,
    first_arrive      character varying,
    first_left_seat   int,
    second_train_num  varchar,
    second_train_type character varying,
    second_price      double precision,
    second_to         character varying,
    second_leave      character varying,
    second_arrive     character varying,
    second_left_seat  int,
    total_time        character varying,
    total_price       double precision
);


--5.8

--更新外键 （昨天忘了

alter table schedule
add constraint fk_train_id
foreign key (train_id)
references train (train_id);

alter table schedule
add constraint fk_station_id
foreign key (station_id)
references station (station_id);


