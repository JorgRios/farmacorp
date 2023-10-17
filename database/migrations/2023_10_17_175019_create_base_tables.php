<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        echo "\n Tabla sucursales";
        Schema::create('sucursales', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150);
            $table->integer('telefono')->nullable();
            $table->text('direccion')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->timestamp('creado_en');
        });

        echo "\n Tabla proveedores";
        Schema::create('proveedores', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 191);
            $table->text('direccion')->nullable();
            $table->integer('telefono')->nullable();
            $table->string('email', 150);
            $table->string('nit', 15)->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->timestamp('creado_en');
        });
        echo "\n Tabla productos";
        Schema::create('productos', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('proveedor_id');
            $table->string('nombre', 250);
            $table->text('descripcion')->nullable();
            $table->float('precio_venta')->nullable();
            $table->float('precio_compra')->nullable();
            $table->date('fecha_vencimiento')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->foreign('proveedor_id')
                    ->references('id')
                    ->on('proveedores')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla usuarios";
        Schema::create('usuarios', function (Blueprint $table) {
            $table->id();
            $table->string('nombre', 150);
            $table->string('usuario', 50);
            $table->string('email', 100);
            $table->string('contrasenia', 100);
            $table->integer('telefono')->nullable();
            $table->text('direccion')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->timestamp('creado_en');
        });
        echo "\n Tabla clientes";
        Schema::create('clientes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('usuario_id');
            $table->string('nombre', 191);
            $table->string('ci', 30);
            $table->string('email', 150);
            $table->integer('telefono')->nullable();
            $table->text('direccion')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->timestamp('creado_en');
            $table->foreign('usuario_id')
                    ->references('id')
                    ->on('usuarios')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla acuerdos";
        Schema::create('acuerdos', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('sucursal_id');
            $table->string('nombre_hospital', 150);
            $table->float('porcentaje_descuento');
            $table->date('inicio_acuerdo');
            $table->date('fin_acuerdo');
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->timestamp('creado_en');
            $table->foreign('sucursal_id')
                    ->references('id')
                    ->on('sucursales')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla ventas";
        Schema::create('ventas', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('cliente_id');
            $table->unsignedBigInteger('sucursal_id');
            $table->unsignedBigInteger('usuario_id');
            $table->unsignedBigInteger('acuerdo_id')->nullable();
            $table->timestamp('fecha');
            $table->enum('forma_cobro', ['Efectivo','Tarjeta','Transferencia','QR'])->nullable()->default('Efectivo');
            $table->text('receta');
            $table->float('descuento_clubcliente')->nullable();
            $table->float('descuento_hospital')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->foreign('cliente_id')
                    ->references('id')
                    ->on('clientes')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
            $table->foreign('sucursal_id')
                    ->references('id')
                    ->on('sucursales')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();

            $table->foreign('usuario_id')
                    ->references('id')
                    ->on('usuarios')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
            $table->foreign('acuerdo_id')
                    ->references('id')
                    ->on('acuerdos')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla venta_productos";
        Schema::create('venta_productos', function (Blueprint $table) {
            $table->unsignedBigInteger('venta_id');
            $table->unsignedBigInteger('producto_id');
            $table->integer('cantidad');
            $table->float('precio_unitario')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->primary(['venta_id', 'producto_id']);
            $table->foreign('venta_id')
                    ->references('id')
                    ->on('ventas')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
            $table->foreign('producto_id')
                    ->references('id')
                    ->on('productos')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla sucursal_productos";
        Schema::create('sucursal_productos', function (Blueprint $table) {
            $table->unsignedBigInteger('sucursal_id');
            $table->unsignedBigInteger('producto_id');
            $table->integer('stock');
            $table->primary(['sucursal_id', 'producto_id']);
            $table->foreign('sucursal_id')
                    ->references('id')
                    ->on('sucursales')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
            $table->foreign('producto_id')
                    ->references('id')
                    ->on('productos')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla facturas";
        Schema::create('facturas', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('venta_id');
            $table->integer('numero');
            $table->dateTime('fecha');
            $table->string('nro_autorizacion', 50)->nullable();
            $table->float('motno_total')->nullable();
            $table->float('descuento_total')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->foreign('venta_id')
                    ->references('id')
                    ->on('ventas')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla club_cliente";
        Schema::create('club_cliente', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('cliente_id');
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->integer('puntos_ganados')->nullable();
            $table->integer('puntos_usados')->nullable();
            $table->foreign('cliente_id')
                    ->references('id')
                    ->on('clientes')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla compras";
        Schema::create('compras', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('proveedor_id');
            $table->dateTime('fecha');
            $table->text('descripcion')->nullable();
            $table->enum('estado', ['Activo','Inactivo'])->nullable()->default('Activo');
            $table->foreign('proveedor_id')
                    ->references('id')
                    ->on('proveedores')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });
        echo "\n Tabla compra_productos";
        Schema::create('compra_productos', function (Blueprint $table) {
            $table->unsignedBigInteger('compra_id');
            $table->unsignedBigInteger('sucursal_id');
            $table->unsignedBigInteger('producto_id');
            $table->integer('cantidad');
            $table->decimal('precio_unitario', 12, 2);
            $table->decimal('descuento', 12, 2)->nullable();
            $table->primary(['compra_id', 'sucursal_id', 'producto_id']);
            $table->foreign('compra_id')
                    ->references('id')
                    ->on('compras')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
            $table->foreign('producto_id')
                    ->references('id')
                    ->on('productos')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();

            $table->foreign('sucursal_id')
                    ->references('id')
                    ->on('sucursales')
                    ->cascadeOnUpdate()
                    ->cascadeOnDelete();
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('base_tables');
    }
};
