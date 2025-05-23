<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class RedirectIfAuthenticated
{
    public function handle($request, Closure $next, ...$guards)
    {
        if (Auth::check()) {
            return response()->json(['message' => 'Ya estás autenticado.'], 403);
        }

        return $next($request);
    }
}
