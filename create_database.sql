-- criação do banco de dados para o cenário de E-commerce 
-- drop database ecommerce;
create database ecommerce;
drop database ecommerce;
use ecommerce;
-- CRIANDO A TABELA CLIENTE
-- DEFINI UMA FUNÇÃO CHECK PARA GARANTIR QUE O TIPO CLIENTE SEJA INSERIDO ADEQUADAMENTE.
CREATE TABLE cliente (
  idCliente INT PRIMARY KEY auto_increment,
  fname VARCHAR(15),
  lname varchar(15),
  tipo_cliente VARCHAR(2) NOT NULL,
  cpf_cnpj VARCHAR(14) NOT NULL,
  endereço VARCHAR(200) NOT NULL,
  telefone VARCHAR(15) NOT NULL,
  email VARCHAR(100) NOT NULL,
  inscricao_estadual VARCHAR(20),
  razao_social VARCHAR(100),
  nome_responsavel VARCHAR(100),
  data_nascimento DATE,
  CONSTRAINT tipo_cliente CHECK (tipo_cliente IN ('PJ', 'PF'))
);

-- criando a tabela produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

-- criando a tabela pagamentos
create table payments(
	id_Client int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(id_Client, idPayment),
	CONSTRAINT fk_id_client foreign key (id_Client) REFERENCES cliente(idCliente)
);


-- criar tabela pedido
-- drop table orders;
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idOrderClient) references cliente(idCliente)
			on update cascade
);
alter table orders auto_increment=1;

desc orders;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);
alter table productStorage auto_increment=1;


-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment=1;

desc supplier;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;


-- tabelas de relacionamentos M:N

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

desc productSeller;

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);
