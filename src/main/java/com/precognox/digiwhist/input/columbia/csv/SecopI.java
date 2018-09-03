package com.precognox.digiwhist.input.columbia.csv;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(schema = "digiwhist_parse_raw", name = "co_secop1")
@Getter
@Setter
public class SecopI {

	@Id
	String uid;
	String anno_cargue_secop;
	String anno_firma_del_contrato;
	String nivel_entidad;
	String orden_entidad;
	String nombre_de_la_entidad;
	String nit_de_la_entidad;
	String codigo_de_la_entidad;
	String id_tipo_de_proceso;
	String tipo_de_proceso;
	String estado_del_proceso;
	String causal_de_otras_formas_de_contratacion_directa;
	String id_regimen_de_contratacion;
	String regimen_de_contratacion;
	String id_objeto_a_contratar;
	String objeto_a_contratar;
	String detalle_del_objeto_a_contratar;
	String tipo_de_contrato;
	String municipio_obtencion;
	String municipio_entrega;
	String municipios_ejecucion;
	String fecha_de_cargue_en_el_secop;
	String numero_de_constancia;
	String numero_de_proceso;
	String numero_del_contrato;
	String cuantia_proceso;
	String id_grupo;
	String nombre_grupo;
	String id_familia;
	String nombre_familia;
	String id_clase;
	String nombre_clase;
	String id_ajudicacion;
	String tipo_identifi_del_contratista;
	String identificacion_del_contratista;
	String nom_raz_social_contratista;
	String dpto_y_muni_contratista;
	String tipo_doc_representante_legal;
	String identific_del_represen_legal;
	String nombre_del_represen_legal;
	String fecha_de_firma_del_contrato;
	String fecha_ini_ejec_contrato;
	String plazo_de_ejec_del_contrato;
	String rango_de_ejec_del_contrato;
	String tiempo_adiciones_en_dias;
	String tiempo_adiciones_en_meses;
	String fecha_fin_ejec_contrato;
	String compromiso_presupuestal;
	String cuantia_contrato;
	String valor_total_de_adiciones;
	String valor_contrato_con_adiciones;
	String objeto_del_contrato_a_la_firma;
	String id_origen_de_los_recursos;
	String origen_de_los_recursos;
	String codigo_bpin;
	String proponentes_seleccionados;
	String calificacion_definitiva;
	String id_sub_unidad_ejecutora;
	String nombre_sub_unidad_ejecutora;
	String moneda;
	String espostconflicto;
	String ruta_proceso_en_secop_i;
}
