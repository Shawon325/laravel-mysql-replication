<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/get-employee', function () {
    return \Illuminate\Support\Facades\DB::table('employees')->get();
});

Route::get('/store-employee', function () {
    \Illuminate\Support\Facades\DB::table('employees')->insert([
        'name' => 'Ridoy',
        'age' => 25,
        'salary' => 5000,
    ]);
});
