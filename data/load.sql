CREATE TABLE IF NOT EXISTS contacts (
                                        customer_key int,
                                        email varchar(256)
);

INSERT INTO `contacts`(`customer_key`, `email`) VALUES(1, 'alice@example.com');