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

INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES (1, 'sony', null) ON CONFLICT DO NOTHING;
INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES (2, 'panasonic', null) ON CONFLICT DO NOTHING;
INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES (3, 'lg', null) ON CONFLICT DO NOTHING;
INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES (4, 'vizio', null) ON CONFLICT DO NOTHING;
INSERT INTO polarity.brands(id, brand_name, last_sold_at) VALUES (5, 'samsung', null) ON CONFLICT DO NOTHING;

-- Manually move our sequence to 6 since we explicitly set our primary key id
ALTER SEQUENCE polarity.brands_id_seq RESTART WITH 6;


-- Insert Sony widgets
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (1, 'walkman', 10, 1) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (2, 'playstation', 5, 1) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (3, 'trinitron television', 10, 1) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (4, 'AIBO', 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (5, 'alpha 6000 camera', 20, 1) ON CONFLICT DO NOTHING;

-- Insert Panasonic widgets
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (6, 'viera television', 5, 2) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (7, 'toaster oven', 15, 2) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (8, 'microwave', 10, 2) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (9, 'camcorder', 2, 2) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (10, 'blueray', 20, 2) ON CONFLICT DO NOTHING;


-- Insert LG widgets
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (11, 'instaview refrigerator', 5, 3) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (12, 'quad wash dishwasher', 15, 3) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (13, 'smart wifi washing machine', 10, 3) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (14, 'oled television', 2, 3) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (15, 'cordzero vacuum', 20, 3) ON CONFLICT DO NOTHING;

-- Insert vizio widgets
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (16, 'v-series television', 5, 4) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (17, '5.1 sound bar', 20, 4) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (18, '2.1 sound bar', 10, 4) ON CONFLICT DO NOTHING;

-- Insert samsung widgets
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (19, 'smart gas range', 5, 5) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (20, 'active jet top load washer', 20, 5) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (21, 'the frame television', 10, 5) ON CONFLICT DO NOTHING;
INSERT INTO polarity.widgets(id, widget_name, quantity, brand_id) VALUES (22, 'galaxy s21 phone', 25, 5) ON CONFLICT DO NOTHING;

-- Manually move our sequence to 6 since we explicitly set our primary key id
ALTER SEQUENCE polarity.widgets_id_seq RESTART WITH 23;