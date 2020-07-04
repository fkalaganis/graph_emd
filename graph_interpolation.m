function interpolated_graph_signal=graph_interpolation(known_graph_signal,known_graph_vertices, A)
% Input:
%   * graph_signal -> Known graph signal values.
%
%   * graph_vertices -> Vertices for which the graph_signal is given.
%
%   * A -> Adjacency matrix that describes the topogoly of graph signal
%
% Output:
%   * num_of_crossings -> Total number of graph zero crossings.
if length(known_graph_signal)~=length(known_graph_vertices)
    error('Error: Number of known vertices should be equal to the number of known samples')
end
if ~issymmetric(A)
    error('Error: Adjacency matrix is not symmetric')
end
if size(known_graph_signal,2)<length(known_graph_signal)
    known_graph_signal=known_graph_signal'
end

L=diag(sum(A))-A;
interpolated_graph_signal=zeros(1,size(L,2));
unknown_vertices=setdiff([1:length(L)], known_graph_vertices);

L_known=L(known_graph_vertices,known_graph_vertices);
L_unknown=L(unknown_vertices,unknown_vertices);
R=L(known_graph_vertices,unknown_vertices);
R_T=L(unknown_vertices,known_graph_vertices);
unknown_signal = linsolve(L_unknown,-R_T*known_graph_signal');
interpolated_graph_signal(unknown_vertices)=unknown_signal;
interpolated_graph_signal(known_graph_vertices)=known_graph_signal;
% extracting graph Laplacian components


end
