create database if not exists dbmoneybin;
use dbmoneybin;
create table deposito
(
    deposito_id int auto_increment
        primary key,
    tipo        varchar(50) not null
);

create table retiro
(
    retiro_id int auto_increment
        primary key,
    tipo      varchar(50) not null,
    limite    int         not null
);

create table servicio
(
    servicio_id int auto_increment
        primary key,
    tipo        varchar(50) not null
);

create table usuario
(
    cui            bigint                                not null
        primary key,
    nombres        varchar(50)                           not null,
    apellidos      varchar(50)                           not null,
    password       varchar(200)                          not null,
    fecha_creacion datetime                              not null,
    rol            enum ('admin', 'personal', 'usuario') not null
);

create table cuenta
(
    cuenta_id int auto_increment
        primary key,
    saldo     int    not null,
    cui       bigint not null,
    constraint cuenta_ibfk_1
        foreign key (cui) references usuario (cui)
);

create index cui
    on cuenta (cui);

create table prestamo
(
    prestamo_id int auto_increment
        primary key,
    fecha       datetime not null,
    saldo       int      not null,
    cuenta_id   int      not null,
    constraint prestamo_ibfk_1
        foreign key (cuenta_id) references cuenta (cuenta_id)
);

create index cuenta_id
    on prestamo (cuenta_id);

create table transaccion
(
    trans_id    int auto_increment
        primary key,
    monto       int                                                 not null,
    tipo        enum ('servicio', 'prestamo', 'retiro', 'deposito') not null,
    fecha       datetime                                            not null,
    cuenta_id   int                                                 not null,
    servicio_id int                                                 null,
    retiro_id   int                                                 null,
    deposito_id int                                                 null,
    prestamo_id int                                                 null,
    encargado   bigint                                              not null,
    constraint transaccion_ibfk_1
        foreign key (cuenta_id) references cuenta (cuenta_id),
    constraint transaccion_ibfk_2
        foreign key (servicio_id) references servicio (servicio_id),
    constraint transaccion_ibfk_3
        foreign key (retiro_id) references retiro (retiro_id),
    constraint transaccion_ibfk_4
        foreign key (deposito_id) references deposito (deposito_id),
    constraint transaccion_ibfk_5
        foreign key (prestamo_id) references prestamo (prestamo_id),
    constraint transaccion_ibfk_6
        foreign key (encargado) references usuario (cui),
    check (((`servicio_id` is not null) and (`retiro_id` is null) and (`deposito_id` is null) and
            (`prestamo_id` is null)) or
           ((`retiro_id` is not null) and (`servicio_id` is null) and (`deposito_id` is null) and
            (`prestamo_id` is null)) or
           ((`deposito_id` is not null) and (`servicio_id` is null) and (`retiro_id` is null) and
            (`prestamo_id` is null)) or
           ((`prestamo_id` is not null) and (`servicio_id` is null) and (`retiro_id` is null) and
            (`deposito_id` is null)))
);

create index cuenta_id
    on transaccion (cuenta_id);

create index deposito_id
    on transaccion (deposito_id);

create index encargado
    on transaccion (encargado);

create index prestamo_id
    on transaccion (prestamo_id);

create index retiro_id
    on transaccion (retiro_id);

create index servicio_id
    on transaccion (servicio_id);

