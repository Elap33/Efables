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
	shape_file Roads0_shape_file <- shape_file("../includes/Roads.shp");
	shape_file PVpoligono <-shape_file("../includes/PV v2.shp");
	geometry shape <- envelope(PVpoligono);
	//shape_file nha20_shape_file <- shape_file("../includes/nha2.shp");
	graph road_network;
	field traffic <- field(100,100);

	
	//shape_file open_vector0_shape_file <- shape_file("../includes/open vector.shp");



	init{
		create road from: Roads0_shape_file;
		//create road from: Roads0_shape_file;
		road_network <- as_edge_graph(road,75);
		create manzanas_PV from:PVpoligono with:[
			pobtot::int(read("POBTOT")),
			Pmas::int(read("P_60YMAS"))
		];
		//create building from:mi_archivo;
		create persona number:120;
		}
		reflex principal{
			ask manzanas_PV{
				
				densidad<- pobtot/shape.area#m2;
			}
			list<float> mi_lista;
			mi_lista <- manzanas_PV collect(each.densidad); 
			float max_dens_value <- max (mi_lista);
			write ""+mi_lista+"\n";
			write max_dens_value;
			ask manzanas_PV{
				densidad <- (densidad/max_dens_value)*100;
			}
			mi_lista <- manzanas_PV collect(each.densidad);
			write mi_lista;	
		}	
		reflex update_heatmap{
			ask persona{
				traffic[location] <- traffic [location] +10;
			}
		}
	}

species persona skills:[moving]{
	point home;
	point destiny;
	int estatura;
	int edad;
	string nombre;
	point ubicacion;
	init{
		home <- any_location_in(one_of (manzanas_PV));
		destiny <- any_location_in(one_of (manzanas_PV));
		location <- home;
		//location <- one_of(building).location;
		location <- one_of(manzanas_PV).location;
		
	}
	reflex movement{
		do goto target: destiny on:road_network;
		if(location=destiny){destiny <- home; }
		//do wander;
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
species road{
	aspect default{
		draw shape color: #mediumblue;
	}
}
species manzanas_PV{
	int pobtot;
	int Pmas;
	float densidad;
	rgb mi_color;
	aspect default{
		if(densidad<0.10){//valor de densidad bajo
		mi_color <- rgb (73, 247, 23, 255);	
		}
		else if(densidad<0.25){
			mi_color <- rgb (48, 143, 55, 255);
		}
		else if(densidad<0.50){
			mi_color <- rgb (233, 237, 63, 255);
		
		}
		else if(densidad<0.75){
			mi_color <- rgb (251, 128, 36, 255);
		}
		else if (densidad<0.85){
			mi_color <- rgb (235, 30, 7, 255); 
		}
		else{
			mi_color <- rgb (146, 33, 134, 255);
		}
		draw shape color:mi_color;
	}
	}
experiment mi_experiment{
	output{
		display mi_vis background: #white{
			//species manzanas_PV aspect:default;
			species building aspect:default;
			species persona aspect:normal; 
			species road aspect:default;
			mesh traffic color: palette ([ #black, #black, #orange, #orange, #red, #red, #red]) smooth:2;
			
			}
		
	}
}
experiment batch type:batch until:cycle>50{
	
}

/* Insert your model definition here */

