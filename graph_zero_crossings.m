function num_of_crossings=graph_zero_crossings(graph_signal,A)
% Input:
%   * graph_signal -> Graph signal (1D vector) defined on vertices.
%
%   * A -> Adjacency matrix that describes the topogoly of graph signal
%
% Output:
%   * num_of_crossings -> Total number of graph zero crossings.


if size(A,1)~=length(graph_signal)
    error('Error: Number of vertices should be equal to the number of samples')
end

% Pairwise products, then keep only the adjacent.
sign_alternation=(graph_signal.*graph_signal').*A;
% A negative between neighbours indicates a crossing (definition)
num_of_crossings=sum(sum(sign_alternation<0))/2;
end
