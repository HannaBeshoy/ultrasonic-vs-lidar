function v = speed_of_sound(T, model)
%SPEED_OF_SOUND  Speed of sound in dry air, m/s, at temperature T in degrees C.
%   v = speed_of_sound(T)              linear model  v = 331.3 + 0.606*T  (the course formula)
%   v = speed_of_sound(T, 'ideal')     ideal gas     v = 331.3*sqrt(1 + T/273.15)
%
%   Sound in a gas travels at sqrt(gamma*R*T/M): it grows with the square root
%   of the absolute temperature. The linear formula is a straight-line fit to
%   it: they agree within 0.2 m/s from -10 to 20 C and drift apart to 0.8 m/s
%   (0.25 %) at 40 C, which is 2.5 mm in 1 m.
if nargin < 2, model = 'linear'; end
switch lower(model)
    case 'linear'
        v = 331.3 + 0.606 * T;
    case 'ideal'
        v = 331.3 * sqrt(1 + T / 273.15);
    otherwise
        error('model must be ''linear'' or ''ideal''');
end
end
