function [min_list, max_list, num_of_extrema]=graph_extrema(graph_signal,A)
% Input:
%   * graph_signal -> Graph signal (1D vector) defined on vertices.
%
%   * A -> Adjacency matrix that describes the topogoly of graph signal
%
% Output:
%   * min_list -> Vector that contain the graph minima vertices of graph
%     signal.
%
%   * max_list -> Vector that contain the graph maxima vertices of graph
%     signal.
%
%   * num_of_extrema -> Total number of graph extrema.

if size(A,1)~=length(graph_signal)
    error('Error: Number of vertices should be equal to the number of samples')
end
if sum(abs(diag(A)))~=0
    % A num cannot be greater than itself
    error('Error: Graph should not contain self connections')
end

max_list=[];
min_list=[];
for i_vertex=1:size(A,1)
    % Check if signal at i_vertex is greater than all its neighbours
    neighbourhood=A(i_vertex,:)~=0;
    max_neighbour=max(graph_signal(neighbourhood));
    if graph_signal(i_vertex)>=max_neighbour
        max_list(end+1)=i_vertex;
    end
    clear max_neighbour % memory housekeeping essntial for large graphs
    
    % Check if signal at i_vertex is smaller than all its neighbours
    min_neighbour=min(graph_signal(neighbourhood));
    if graph_signal(i_vertex)<=min_neighbour
        min_list(end+1)=i_vertex;
    end
end
num_of_extrema=length(min_list)+length(max_list);
end