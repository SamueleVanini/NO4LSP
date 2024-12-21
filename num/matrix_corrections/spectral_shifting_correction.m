function Bk = spectral_shifting_correction(Hk, toleig)

    min_eig = eigs(Hk, 1, 'smallestreal'); % Compute smallest eigenvalue
    tauk = max(0, toleig - min_eig); % Compute correction
    Bk = Hk + tauk * eye(size(Hk)); %  Add correction
end