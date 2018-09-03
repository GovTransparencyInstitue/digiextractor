package com.precognox.digiwhist.input.columbia.csv;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(schema = "digiwhist_parse_raw", name = "co_secop2_contratos")
@Getter
@Setter
public class Secop2Contratos {


	String nombre_entidad;
	String nit_entidad;
	String proceso_de_compra;
	String descripcion_del_proceso;
	String tipo_de_contrato;
	@Id
	String referencia_del_contrato;
	String fecha_de_inicio_del_contrato;
	String fecha_de_fin_del_contrato;
	String fecha_de_inicio_de_ejecucion;
	String fecha_de_fin_de_ejecucion;
	String condiciones_de_entrega;
	String proveedor_adjudicado;
	String es_grupo;
	String estado_contrato;
	String habilita_pago_adelantado;
	String liquidacion;
	String obligaciones_ambientales;
	String obligaciones_postconsumo;
	String reversion;
	String valor_del_contrato;
	String valor_de_pago_adelantado;
	String valor_facturado;
	String valor_pendiente_de_pago;
	String valor_pagado;
	String valor_amortizado;
	String valor_pendiente_de_amortizacion;
	String valor_pendiente_de_ejecucion;
	String codigo_de_categoria_principal;
	String tipo_de_proceso;
	String fecha_de_firma;
	String estado_bpin;
	String anno_bpin;
	String codigo_bpin;
}
