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

--5.9

--经过多次对比 建一个查询专用表有明显效率提升
--另 path_recommend 临时表里的结果是不换乘和一次换乘的union 因为列数必须一样 且不能返回null '' ' '等无关内容 
--所以暂时设定的是不换乘的第二班列车信息和第一班相同 展示结果时只需根据first_to是否为目的地作if判断 

CREATE TABLE inquire_table
(
    train_num                varchar(5)       DEFAULT NULL,
    stop_num                 int              DEFAULT NULL,
    station_name             varchar(10)      DEFAULT NULL,
    arrive_time              varchar(10)      DEFAULT NULL,
    depart_time              varchar(10)      DEFAULT NULL,
    train_type               varchar(5)       DEFAULT NULL,
    price_from_start_station double precision default null,
    spear_seat               int              default null
);

alter table inquire_table
    add constraint pr_key
        primary key (train_num, stop_num);

--插入语句和之前的一样 记得改一下表的名字 插入之后调用 modify_price算票价

update inquire_table
set price_from_start_station=modify_price(train_num, stop_num, train_type, arrive_time);

