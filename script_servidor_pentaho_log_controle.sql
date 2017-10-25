DO $$
BEGIN


--  SET statement_timeout = 0;
--  SET lock_timeout = 0;
    SET client_encoding = 'UTF8';
--  SET standard_conforming_strings = on;
--  SET check_function_bodies = false;
--  SET client_min_messages = warning;
--  SET row_security = off;

--  CREATE DATABASE etl;

    CREATE SCHEMA IF NOT EXISTS etl;      -- SCHEMA DEVE SER IGUAL AO QUE ESTÁ NO KETTLE.PROPERTIES

    SET search_path = etl, pg_catalog;    -- SCHEMA DEVE SER IGUAL AO QUE ESTÁ NO KETTLE.PROPERTIES

--  SET default_tablespace = '';

--  SET default_with_oids = false;


    CREATE TABLE IF NOT EXISTS channel (
        id_batch integer,
        channel_id character varying(255),
        log_date timestamp without time zone,
        logging_object_type character varying(255),
        object_name character varying(255),
        object_copy character varying(255),
        repository_directory character varying(255),
        filename character varying(255),
        object_id character varying(255),
        object_revision character varying(255),
        parent_channel_id character varying(255),
        root_channel_id character varying(255)
    );

    CREATE TABLE IF NOT EXISTS job (
        id_job integer,
        channel_id character varying(255),
        jobname character varying(255),
        status character varying(15),
        lines_read bigint,
        lines_written bigint,
        lines_updated bigint,
        lines_input bigint,
        lines_output bigint,
        lines_rejected bigint,
        errors bigint,
        startdate timestamp without time zone,
        enddate timestamp without time zone,
        logdate timestamp without time zone,
        depdate timestamp without time zone,
        replaydate timestamp without time zone,
        log_field text
    );

    CREATE TABLE IF NOT EXISTS job_entry (
        id_batch integer,
        channel_id character varying(255),
        log_date timestamp without time zone,
        transname character varying(255),
        stepname character varying(255),
        lines_read bigint,
        lines_written bigint,
        lines_updated bigint,
        lines_input bigint,
        lines_output bigint,
        lines_rejected bigint,
        errors bigint,
        result boolean,
        nr_result_rows bigint,
        nr_result_files bigint
    );

    CREATE TABLE IF NOT EXISTS transformation (
        id_batch integer,
        channel_id character varying(255),
        transname character varying(255),
        status character varying(15),
        lines_read bigint,
        lines_written bigint,
        lines_updated bigint,
        lines_input bigint,
        lines_output bigint,
        lines_rejected bigint,
        errors bigint,
        startdate timestamp without time zone,
        enddate timestamp without time zone,
        logdate timestamp without time zone,
        depdate timestamp without time zone,
        replaydate timestamp without time zone,
        log_field text
    );

    CREATE TABLE IF NOT EXISTS transformation_metric (
        id_batch integer,
        channel_id character varying(255),
        log_date timestamp without time zone,
        metrics_date timestamp without time zone,
        metrics_code character varying(255),
        metrics_description character varying(255),
        metrics_subject character varying(255),
        metrics_type character varying(255),
        metrics_value bigint
    );

    CREATE TABLE IF NOT EXISTS transformation_performance (
        id_batch integer,
        seq_nr integer,
        logdate timestamp without time zone,
        transname character varying(255),
        stepname character varying(255),
        step_copy integer,
        lines_read bigint,
        lines_written bigint,
        lines_updated bigint,
        lines_input bigint,
        lines_output bigint,
        lines_rejected bigint,
        errors bigint,
        input_buffer_rows bigint,
        output_buffer_rows bigint
    );

    CREATE TABLE IF NOT EXISTS transformation_step (
        id_batch integer,
        channel_id character varying(255),
        log_date timestamp without time zone,
        transname character varying(255),
        stepname character varying(255),
        step_copy smallint,
        lines_read bigint,
        lines_written bigint,
        lines_updated bigint,
        lines_input bigint,
        lines_output bigint,
        lines_rejected bigint,
        errors bigint
    );

    IF to_regclass('idx_job_1') IS NULL THEN
    CREATE INDEX idx_job_1 ON job USING btree (id_job);
    END IF;

    IF to_regclass('idx_job_2') IS NULL THEN
    CREATE INDEX idx_job_2 ON job USING btree (errors, status, jobname);
    END IF;

    IF to_regclass('idx_job_entry_1') IS NULL THEN
    CREATE INDEX idx_job_entry_1 ON job_entry USING btree (id_batch);
    END IF;

    IF to_regclass('idx_transformation_1') IS NULL THEN
    CREATE INDEX idx_transformation_1 ON transformation USING btree (id_batch);
    END IF;

    IF to_regclass('idx_transformation_2') IS NULL THEN
    CREATE INDEX idx_transformation_2 ON transformation USING btree (errors, status, transname);
    END IF;


    CREATE TABLE IF NOT EXISTS etl_controle_execucao
    (
      id bigserial NOT NULL,
      cliente_id character varying(100) NOT NULL,
      cliente_nome character varying(400) NOT NULL,
      cliente_uf character varying(2) NOT NULL,
      job_nome character varying(400) NOT NULL,
      data_cadastro date NOT NULL DEFAULT now(),
      habilitado boolean DEFAULT true,
      executando boolean DEFAULT false,
      execucao_inicio timestamp without time zone,
      execucao_fim timestamp without time zone,
      CONSTRAINT controle_etl_pkey PRIMARY KEY (id),
      CONSTRAINT controle_etl_uniq_cliente_id_job UNIQUE (cliente_id, job_nome)
    );

    CREATE TABLE IF NOT EXISTS etl_historico_execucao
    (
      id bigserial NOT NULL,
      cliente_id character varying(100) NOT NULL,
      cliente_nome character varying(400) NOT NULL,
      cliente_uf character varying(2) NOT NULL,
      job_nome character varying(400) NOT NULL,
      status character varying(50) NOT NULL,
      data_registro timestamp without time zone,
      CONSTRAINT etl_historico_execucao_pkey PRIMARY KEY (id)
    );


END $$;