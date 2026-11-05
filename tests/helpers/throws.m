function t = throws(f)
%THROWS  True if calling f raises an error.
try
    f();
    t = false;
catch
    t = true;
end
end
