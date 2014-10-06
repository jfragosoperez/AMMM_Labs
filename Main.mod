/*********************************************
 * OPL 12.5.1.0 Model
 * Author: 1127051
 * Creation Date: 29/09/2014 at 10:56:05
 *********************************************/
//Main

main {
	var src = new IloOplModelSource("WorkloadCPU.mod");
	var def = new IloOplModelDefinition(src);
	var cplex = new IloCplex();
	var model = new IloOplModel(def,cplex);
	var data = new IloOplDataSource("WorkloadCPU.dat");
	model.addDataSource(data);
	model.generate();
	cplex.epgap=0.01;
	if (cplex.solve()) {
		writeln("Max load " + cplex.getObjValue() + "%");
		for (var c=1;c<=model.nCPUs;c++) {
			var load=0;
			for (var t=1;t<=model.nTasks;t++)
			load+=(model.rt[t]* model.x_tc[t][c]);
			load = (1/model.rc[c])*load;
			writeln("CPU " + c + " loaded at " + load + "%");
		}		
	}
	else {
		writeln("Not solution found");
	}  
	
	model.end();
	data.end();
	def.end();
	cplex.end();
	src.end();
};