CREATE SCHEMA IF NOT EXISTS polarity;
SET search_path = polarity, pg_catalog;

CREATE TABLE IF NOT EXISTS polarity.brands
(
    id serial NOT NULL,
    brand_name character varying(256) NOT NULL,
    last_sold_at timestamp with time zone,
    CONSTRAINT brands_id_pkey PRIMARY KEY (id)
)
    WITH (
        OIDS=FALSE
    );
ALTER TABLE polarity.brands
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS polarity.widgets
(
    id serial NOT NULL,
    widget_name character varying(256) NOT NULL,
    quantity integer NOT NULL DEFAULT 0,
    brand_id integer NOT NULL,
    CONSTRAINT widgets_id_pkey PRIMARY KEY (id),
    CONSTRAINT widgets_brand_id_fkey FOREIGN KEY (brand_id)
        REFERENCES polarity.brands (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
)
    WITH (
        OIDS=FALSE
    );
ALTER TABLE polarity.widgets
    OWNER TO postgres;

-- Manually insert test data
INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES 
 (1, 'sony', null),
 (2, 'panasonic', null),
 (3, 'lg', null),
 (4, 'vizio', null),
 (5, 'samsung', null)
ON CONFLICT DO NOTHING;

-- Manually move our sequence to 6 since we explicitly set our primary key id
ALTER SEQUENCE polarity.brands_id_seq RESTART WITH 6;

INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES 
-- Insert Sony widgets
 (1, 'walkman', 10, 1),
 (2, 'playstation', 5, 1),
 (3, 'trinitron television', 10, 1),
 (4, 'AIBO', 1, 1),
 (5, 'alpha 6000 camera', 20, 1),

-- Insert Panasonic widgets
 (6, 'viera television', 5, 2),
 (7, 'toaster oven', 15, 2),
 (8, 'microwave', 10, 2),
 (9, 'camcorder', 2, 2),
 (10, 'blueray', 20, 2),

-- Insert LG widgets
 (11, 'instaview refrigerator', 5, 3),
 (12, 'quad wash dishwasher', 15, 3),
 (13, 'smart wifi washing machine', 10, 3),
 (14, 'oled television', 2, 3),
 (15, 'cordzero vacuum', 20, 3),

-- Insert Vizio widgets
 (16, 'v-series television', 5, 4),
 (17, '5.1 sound bar', 20, 4),
 (18, '2.1 sound bar', 10, 4),

-- Insert Samsung widgets
 (19, 'smart gas range', 5, 5),
 (20, 'active jet top load washer', 20, 5),
 (21, 'the frame television', 10, 5),
 (22, 'galaxy s21 phone', 25, 5)
ON CONFLICT DO NOTHING;

-- Manually move our sequence to 6 since we explicitly set our primary key id
ALTER SEQUENCE polarity.widgets_id_seq RESTART WITH 23;
