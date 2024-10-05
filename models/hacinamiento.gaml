/**
* Name: home
* Based on the internal empty template. 
* Author: sharl
* Tags: 
*/


model modelo_de_Prueba

global{
	//geometry shape <- square(1000#m);
	//shape_file mi_archivo <-shape_file("../includes/nha2.shp");
	shape_file PVpoligono <-shape_file("../includes/PV v2.shp");
	geometry shape <- envelope(PVpoligono);
	//shape_file nha20_shape_file <- shape_file("../includes/nha2.shp");

	init{
		create manzanas_PV from:PVpoligono with:[
			hacinamiento::int(read("PROM_OCUP"))
		];
		//create building from:mi_archivo;
		write manzanas_PV collect(each.hacinamiento);
		create persona number:120;
		}
		reflex principal{
			
			list<float> mi_lista;
			mi_lista <- manzanas_PV collect(each.hacinamiento); 
			
			float max_pro_ocup_value <- max (mi_lista);
			write mi_lista;
			write max_pro_ocup_value;
			ask manzanas_PV{
				hacinamiento <- (hacinamiento/max_pro_ocup_value);
			}
			mi_lista <- manzanas_PV collect(each.hacinamiento);
			write mi_lista;	
		}	
	}

species persona skills:[moving]{
	int estatura;
	int edad;
	string nombre;
	point ubicacion;
	init{
		//location <- one_of(building).location;
		location <- one_of(manzanas_PV).location;	
	}
	reflex{
		do wander;
	}
	aspect normal{
		draw circle(10)color:#fuchsia;
	}
}
species building{
	aspect default{
		draw shape;
	}
	
}
species manzanas_PV{
	int pro_ocup;
	float hacinamiento;
	rgb mi_color;
	aspect default{
		if(hacinamiento<0.25){//valor de hacinamiento bajo
		mi_color <- rgb (73, 247, 23, 255);	
		}
		else if(hacinamiento<0.50){
			mi_color <- rgb (233, 237, 63, 255);
		}
		else if(hacinamiento<0.75){
			mi_color <- rgb (251, 128, 36, 255);
		}
		else{
			mi_color <- rgb (158, 54, 62, 255);
		}
		draw shape color:mi_color;
	}
	}
experiment mi_experiment{
	output{
		display mi_vis background:#black{
			species manzanas_PV aspect:default;
			species building aspect:default;
			species persona aspect:normal; 
			}
		
	}
}
experiment batch type:batch until:cycle>50{
	
}

/* Insert your model definition here */

