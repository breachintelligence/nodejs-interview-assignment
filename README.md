# Assignment Overview

Create an Express or Fastify based REST API for a Widget Store.   

The widget store has 1 or more widgets and each widget has a single brand. A brand can have multiple widgets. The store should query a PostgreSQL database (version 12+).  We have provided both a postgresql schema file and initial test data which can be used to seed the database.

Please ensure your submission is representative of the code you would produce professionally.

The assignment is expected to take between 2 and 3 hours.  If you have additional items you would want to tackle but don't have time please feel free to provide that to us when submitting the assignment.


# General Requirements

* Your implementation can utilize Express (https://expressjs.com/) or Fastify (https://fastify.io)
* You can access the PostgreSQL database however you choose.  Possible options include direct SQL (node-pg), an ORM (TypeORM, sequelize etc.), or a thin database wrapper (slonik). 
* Please use NodeJS 12+ (12, 14, or 16)
* You can organize your code however you want
* If you'd like to point out a specific capability or a thought process, feel free to leave a code comment in the appropriate location
* Provide a couple of lines of documentation on how you would like us to run your project


# The Models

## Widget

The following are the attributes for the widget

* id {serial}, auto incrementing primary key
* widget_name {character varying(256)}, name of the widget
* quantity {integer}, the number of widgets that are available for purchase
    * This value should not be less than zero (not enforced by the provided database schema by default)
* brand_id {integer}, foreign key, provides the associated brand for this widget


## Brand

The following are the attributes for the brand

* id {serial}, auto incrementing primary key
* brand_name {character varying(256)}, name of the brand
* last_sold_at {timestamp without time zone}, date when an associated widget was last sold
     * should update if an associated widget quantity decreases

# Required REST Capabilities

The REST API should support the following capabilities:

1. Create a widget
   * Specify the widget, associated brand, and initial quantity   
   * If a widget with the same name (case insensitive) and brand already exists, return an error
2. List all widgets
   * Return a list of widgets
3. Incrementing and Decrementing a widget's quantity
   * You can implement this however you want but your implementation should account for multiple users of the API potentially updating the widget quantity at the same time
   * If a widget quantity is decremented, the associated brands `last_sold_at` timestamp should be updated to reflect the time at which the widget quantity was decreased.
4. Delete a brand 
   * Deleting a brand should delete all associated widgets

# Additional Notes

1. You can make adjustments to the database schema as you see fit so long as existing columns are all present.  For example, if you wanted to add a database constraint, or index you are more than welcome to do so.

# Running PostgreSQL via Docker

We've provided the following instructions on how you can get a PostgreSQL database up and running quickly via Docker using the official PostgreSQL Docker image.  To begin, you will need to install Docker by following the directions available here: https://docs.docker.com/get-docker/

Note that you do not need to use PostgreSQL via Docker and you are welcome to install PostgreSQL via other methods (e.g., via the Windows installer, RPMs, homebrew etc.).

Pull down the postgres docker container (for more information on the PostgreSQL docker container please see https://hub.docker.com/_/postgres)

```bash
docker pull postgres
```

Launch and initialize the PostgresQL docker container.  Note that this command will map `/var/lib/postgresql/data`, which contains the database data in the container, to `pgdata` on your local filesystem.  This command will also set the default `postgres` user password to `mysecretpassword`.  The command adds the `init-schema.sql` file to the container and uses it to initialize the database. Finally, the command maps port 5432 in the container to port 5432 on the local operating system (port 5432 being the default PostgreSQL port) so that you can connect to the database from outside the container.

> You should run this command from inside the `nodejs-interview-assignment` repo that you cloned.

```bash
docker run -d \
  --name polarity-postgres-interview  \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v "$(pwd)/pgdata:/var/lib/postgresql/data" \
  -v "$(pwd)/sql/init-schema.sql:/docker-entrypoint-initdb.d/init-schema.sql" \ 
  -p 5432:5432  \
  postgres
```

By default, you can use the following credentials to connect to PostgreSQL running in the docker container:

```
host: localhost
user: postgres
password: mysecretpassword
database: postgres
port: 5432
```

# PostgreSQL Database Definitions

The following walks through the SQL  used to initialize the database and are provided in case you wish to initialize your database differently than specified above.  The widget and brand tables are created in the `polarity` schema. 

The below statements are all included in the `sql/init-schema.sql` file.

### Database Schema

```postgresql
-- All tables are created in the `polarity` schema
CREATE SCHEMA IF NOT EXISTS polarity;
SET search_path = polarity, pg_catalog;
```

### brands table definition

```postgresql
CREATE TABLE polarity.brands
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
```

### widgets table definition

```postgresql
CREATE TABLE polarity.widgets
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
```

### Insert Statements to Seed Test Data

```postgresql
-- Insert Brands
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
```

# Additional psql commands

The following `psql` commands may be useful if you are making use of the command line tool.  To connect to your PostgreSQL database you can run the following command:

```bash
PGPASSWORD=mysecretpassword psql -h localhost -p 5432 -U postgres
```

If you did not initialize your PostgreSQL database via the `docker run` command provided earlier, you can manually initialize it by running the `init-schema.sql` file like this:

```bash
PGPASSWORD=mysecretpassword psql -h localhost -p 5432 -U postgres -d postgres -f init-schema.sql
```

You can confirm the test data loaded with the following command:

```bash
PGPASSWORD=mysecretpassword psql -h localhost -p 5432 -U postgres -d postgres -c 'SELECT * FROM polarity.widgets'
```
