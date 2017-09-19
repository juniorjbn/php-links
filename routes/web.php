<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|

#Comentei aqui
Route::get('/', function () {
    return view('welcome');
});
*/

Route::get('/', function () {
    $links = \App\Link::all();
    return view('welcome', ['links' => $links]);
});

Route::get('/submit', function () {
    return view('submit');
});

use Illuminate\Http\Request;

Route::post('/submit', function(Request $request) {
    $validator = Validator::make($request->all(), [
        'title' => 'required|max:255',
        'url' => 'required|max:255',
        'description' => 'required|max:255',
    ]);
    if ($validator->fails()) {
        return back()
            ->withInput()
            ->withErrors($validator);
    }
    $link = new \App\Link;
    $link->title = $request->title;
    $link->url = $request->url;
    $link->description = $request->description;
    $link->save();
    return redirect('/');
});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
